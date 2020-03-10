package org.gs.process;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;

import org.compiere.process.ProcessInfoParameter;
import org.compiere.process.SvrProcess;
import org.compiere.util.DB;
import org.compiere.util.Env;

public class UpdateCorrectCurrentQty extends SvrProcess
{
	int p_M_Product_ID = 0 ; 
	@Override
	protected void prepare() 
	{
		ProcessInfoParameter[] para = getParameter();
		for (int i = 0; i < para.length; i++) {
			String name = para[i].getParameterName();
			
			if (para[i].getParameter() == null)
				;
			else if (name.equals("M_Product_ID"))
				p_M_Product_ID = para[i].getParameterAsInt();
			else
				log.log(Level.SEVERE, "Unknown Parameter: " + name);
		}
		
	}

	@Override
	protected String doIt() throws Exception 
	{
		updateCurrentQty();
		
		return "@OK@";
	}

	private void updateCurrentQty() throws SQLException 
	{
		String sqlWhere = "";
		if(p_M_Product_ID>0)
			sqlWhere = " and M_Product_ID="+p_M_Product_ID;
		
		String sql = "Select distinct M_Product_ID From gs_rv_unposted where ad_client_id = ? AND M_Product_ID > 0 "+sqlWhere;
		PreparedStatement pstmt = null;
		ResultSet rs = 	null;
		pstmt = DB.prepareStatement(sql, get_TrxName());
		pstmt.setInt(1, getAD_Client_ID());
		rs = pstmt.executeQuery();
		int totalCount = 0 ;
		while(rs.next())
		{
			int M_Product_ID = rs.getInt("M_Product_ID");
			BigDecimal currentQty = getCurrentQty(M_Product_ID);
			int i = DB.executeUpdate("Update M_Cost Set CurrentQty = ? where M_Product_ID = ? and CurrentQty<? ",new Object[]{currentQty,M_Product_ID,currentQty},false,get_TrxName());
			if(i>0)
				totalCount++;
				
		}
		addLog("Total Updated: "+totalCount);
	}

	private BigDecimal getCurrentQty(int M_Product_ID) 
	{
		BigDecimal shipmentQty = DB.getSQLValueBD(get_TrxName(), "select coalesce(sum(line.movementqty),0) "
																+ "from rv_unposted rv,m_inout inout ,m_inoutline line "
																+ "where rv.record_id=inout.m_inout_id and inout.m_inout_id=line.m_inout_id "
																+ "and rv.ad_table_id=319 "
																+ "and line.m_product_id is not null "
																+ "and rv.docstatus not in ('DR','IN')"
																+ "and line.M_Product_ID = ? ", M_Product_ID);
		
		BigDecimal internalUseQty = DB.getSQLValueBD(get_TrxName(), "select coalesce(sum(line.QtyInternalUse),0) "
				+ "from rv_unposted rv,M_Inventory inv ,M_Inventoryline line,C_DocType type "
				+ "where rv.record_id=inv.M_Inventory_id "
				+ "and inv.M_Inventory_id=line.M_Inventory_id "
				+ "and inv.C_DocType_ID=type.C_DocType_ID "
				+ "and rv.ad_table_id=321 "
				+ "and line.m_product_id is not null "
				+ "and rv.docstatus not in ('DR','IN') "
				+ "and line.M_Product_ID = ? "
				+ "and type.docsubtypeinv='IU' ", M_Product_ID);
		
		BigDecimal physicalQty = DB.getSQLValueBD(get_TrxName(), "select coalesce(sum(line.QtyBook),0)-coalesce(sum(line.QtyCount),0) "
				+ "from rv_unposted rv,M_Inventory inv ,M_Inventoryline line,C_DocType type "
				+ "where rv.record_id=inv.M_Inventory_id "
				+ "and inv.M_Inventory_id=line.M_Inventory_id "
				+ "and inv.C_DocType_ID=type.C_DocType_ID "
				+ "and rv.ad_table_id=321 "
				+ "and line.m_product_id is not null "
				+ "and rv.docstatus not in ('DR','IN') "
				+ "and line.M_Product_ID = ? "
				+ "and type.docsubtypeinv='PI' ", M_Product_ID);
		
		BigDecimal reversedPhysicalQty = DB.getSQLValueBD(get_TrxName(), " select coalesce(sum(line.QtyCount),0)  " + 
				"				 from M_Inventory inv ,M_Inventoryline line,C_DocType type   " + 
				"				 where inv.M_Inventory_id=line.M_Inventory_id   " + 
				"				 and inv.C_DocType_ID=type.C_DocType_ID   " + 
				"				 and line.m_product_id is not null   " + 
				"				 and inv.docstatus='RE'   " + 
				"				 and line.M_Product_ID = ?   " + 
				"				 and type.docsubtypeinv='PI'  " + 
				"				 and inv.Posted!='Y' ", M_Product_ID);
		
		
		BigDecimal QtyOnHand = DB.getSQLValueBD(get_TrxName(), "select coalesce(sum(qtyonhand),0) from m_storageonhand where m_product_id= ? ", M_Product_ID);
		if(QtyOnHand.compareTo(Env.ZERO)<0)
			QtyOnHand = Env.ZERO;
		
		return shipmentQty.add(internalUseQty).add(QtyOnHand).add(physicalQty).add(reversedPhysicalQty);
	}
	

}
