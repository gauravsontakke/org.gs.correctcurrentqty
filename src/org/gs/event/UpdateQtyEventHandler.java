package org.gs.event;

import java.math.BigDecimal;
import java.util.Properties;

import org.adempiere.base.event.AbstractEventHandler;
import org.adempiere.base.event.IEventTopics;
import org.compiere.model.MAcctSchema;
import org.compiere.model.MClient;
import org.compiere.model.MCost;
import org.compiere.model.MInOut;
import org.compiere.model.MInOutLine;
import org.compiere.model.MInventory;
import org.compiere.model.MProduct;
import org.compiere.model.PO;
import org.compiere.util.DB;
import org.compiere.util.Env;
import org.osgi.service.event.Event;

public class UpdateQtyEventHandler extends AbstractEventHandler
{
	Properties ctx = Env.getCtx();
	String trxName = null;
	@Override
	protected void doHandleEvent(Event event) 
	{
		PO po = getPO(event);
		trxName = po.get_TrxName();
		MClient client = MClient.get(ctx);
		if(po instanceof MInOut)
		{
			MInOut inout = (MInOut)po;
			if(inout.isSOTrx())
			{
				MAcctSchema as = null;
				as = client.getAcctSchema();
				MInOutLine[] lines = inout.getLines();
				for(MInOutLine line : lines)
				{
					MProduct product = (MProduct)line.getM_Product();
					MCost cost = product.getCostingRecord(as, line.getAD_Org_ID(), 0);
					BigDecimal currentQty = cost.getCurrentQty();
					BigDecimal movementQty = line.getMovementQty();
					BigDecimal totalQtyAfterPosting = movementQty.subtract(currentQty);
					if(totalQtyAfterPosting.compareTo(Env.ZERO)<0)
					{
						BigDecimal QtyOnHand = DB.getSQLValueBD(trxName, "select coalesce(sum(qtyonhand),0) from m_storageonhand where m_product_id= ? ", product.getM_Product_ID());
						if(QtyOnHand.compareTo(Env.ZERO)<0)
							QtyOnHand = Env.ZERO;
						cost.setCurrentQty(QtyOnHand.add(movementQty));
						cost.saveEx();
					}
				}
			}
		}
		if(po instanceof MInventory)
		{
			
		}
	}

	@Override
	protected void initialize() {

		registerTableEvent(IEventTopics.DOC_BEFORE_POST, MInOut.Table_Name);
		registerTableEvent(IEventTopics.DOC_BEFORE_POST, MInventory.Table_Name);
	}



}
