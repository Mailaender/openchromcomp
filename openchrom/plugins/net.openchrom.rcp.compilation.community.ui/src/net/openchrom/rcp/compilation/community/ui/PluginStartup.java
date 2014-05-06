/*******************************************************************************
 * Copyright (c) 2014 Dr. Philip Wenig.
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * Dr. Philip Wenig - initial API and implementation
 *******************************************************************************/
package net.openchrom.rcp.compilation.community.ui;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.ui.IStartup;

import net.chemclipse.rcp.app.ui.support.UpdateSiteSupport;

public class PluginStartup implements IStartup {

	@Override
	public void earlyStartup() {

		UpdateSiteSupport updateSiteSupport = new UpdateSiteSupport();
		/*
		 * Remove all existing update sites.
		 */
		updateSiteSupport.removeProvisioningRepositories();
		/*
		 * Set unique new update sites.
		 */
		Map<String, String> updateSites = new HashMap<String, String>();
		updateSites.put("OpenChrom Community Edition", "http://update.openchrom.net/repositories/community/0.9.x/repository");
		updateSites.put("OpenChrom 3rd Party Libraries", "http://update.openchrom.net/repositories/community/0.9.x/plugins/openchrom3rdpl"); // 3rd Party Libraries
		updateSites.put("OpenChrom Keys", "http://update.openchrom.net/repositories/community/0.9.x/plugins/openchromkeys"); // Keys Support
		updateSites.put("OpenChrom Icons", "http://update.openchrom.net/repositories/community/0.9.x/plugins/enterprisesupport"); // Enterprise Icons
		updateSites.put("OpenChrom xIdent", "http://update.openchrom.net/repositories/community/0.9.x/plugins/xident"); // xIdent Support
		updateSiteSupport.addProvisioningRepositories(updateSites);
	}
}
