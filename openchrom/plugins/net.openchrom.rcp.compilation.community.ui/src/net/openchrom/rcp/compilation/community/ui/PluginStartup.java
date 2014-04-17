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
		updateSites.put("ChemClipse", "http://updates.openchrom.net/chemclipse/0.9.x/repository");
		updateSites.put("OpenChrom Keys", "http://updates.openchrom.net/plugins/keys/updates/0.9.x");
		updateSites.put("OpenChrom Icons", "http://updates.openchrom.net/plugins/icons/updates/0.9.x"); // Enterprise Icons
		updateSites.put("OpenChrom xIdent", "http://updates.openchrom.net/plugins/identifier/xident/updates/0.9.x");
		updateSiteSupport.addProvisioningRepositories(updateSites);
	}
}
