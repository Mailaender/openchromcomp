/*******************************************************************************
 * Copyright (c) 2012, 2014 Philip (eselmeister) Wenig.
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * openchrom - initial API and implementation
 *******************************************************************************/
package net.openchrom.rcp.compilation.community.ui.preferences;

import java.net.MalformedURLException;
import java.net.URL;

import org.eclipse.epp.mpc.ui.CatalogDescriptor;
import org.eclipse.epp.mpc.ui.MarketplaceClient;
import org.eclipse.jface.preference.FieldEditorPreferencePage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPreferencePage;

import net.openchrom.logging.core.Logger;
import net.openchrom.rcp.compilation.community.ui.Activator;
import net.openchrom.support.ui.preferences.fieldeditors.LabelFieldEditor;
import net.openchrom.support.ui.preferences.fieldeditors.SpacerFieldEditor;

public class MarketplacePreferencePage extends FieldEditorPreferencePage implements IWorkbenchPreferencePage {

	private static final Logger logger = Logger.getLogger(MarketplacePreferencePage.class);

	public MarketplacePreferencePage() {

		super(GRID);
		// The preference store is not needed.
		setDescription("Add the OpenChrom Marketplace on demand, to fetch additional plug-ins. It is still included in the OpenChrom release. Hence, it's only needed when using the OpenChrom plug-ins in a regular Eclipse IDE.");
	}

	@Override
	public void init(IWorkbench workbench) {

	}

	@Override
	protected void createFieldEditors() {

		addField(new SpacerFieldEditor(getFieldEditorParent()));
		addField(new LabelFieldEditor("Note: The marketplace is still included in the regular OpenChrom release.", getFieldEditorParent()));
		/*
		 * Add additional update sites.
		 */
		Button addMarketplace = new Button(getFieldEditorParent(), SWT.NONE);
		addMarketplace.setText("Add OpenChrom Marketplace");
		addMarketplace.addSelectionListener(new SelectionAdapter() {

			@Override
			public void widgetSelected(SelectionEvent e) {

				/*
				 * Delete all settings, all installed plug-ins, everything.
				 */
				MessageBox messageBox = new MessageBox(Display.getCurrent().getActiveShell(), SWT.ICON_INFORMATION | SWT.YES | SWT.NO | SWT.CANCEL);
				messageBox.setText("Add OpenChrom Marketplace");
				messageBox.setMessage("Do you really want to add the OpenChrom marketplace?");
				if(messageBox.open() == SWT.YES) {
					try {
						URL url = new URL("http://openchrom.dyndns.org/");
						CatalogDescriptor catalogDescriptor = new CatalogDescriptor(url, "OpenChrom Marketplace");
						catalogDescriptor.setDescription("Install new plug-ins from the OpenChrom marketplace.");
						catalogDescriptor.setIcon(Activator.imageDescriptorFromPlugin(Activator.PLUGIN_ID, "icons/logo_32x32.png"));
						catalogDescriptor.setInstallFromAllRepositories(false);
						MarketplaceClient.addCatalogDescriptor(catalogDescriptor);
					} catch(MalformedURLException e1) {
						logger.warn(e1);
					}
				}
			}
		});
	}
}
