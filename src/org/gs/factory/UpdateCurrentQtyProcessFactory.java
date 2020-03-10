package org.gs.factory;

import org.adempiere.base.IProcessFactory;
import org.compiere.process.ProcessCall;
import org.gs.process.UpdateCorrectCurrentQty;

public class UpdateCurrentQtyProcessFactory implements IProcessFactory{

	@Override
	public ProcessCall newProcessInstance(String className) 
	{
		if(className.equalsIgnoreCase(UpdateCorrectCurrentQty.class.getName()))
			return new UpdateCorrectCurrentQty();
		
		return null;
	}


}
