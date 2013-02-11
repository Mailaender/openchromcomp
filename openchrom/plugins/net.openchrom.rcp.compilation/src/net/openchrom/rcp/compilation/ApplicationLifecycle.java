/*******************************************************************************
 * Copyright (c) 2013 Philip (eselmeister) Wenig.
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * Philip (eselmeister) Wenig - initial API and implementation
 *******************************************************************************/
package net.openchrom.rcp.compilation;

import org.eclipse.e4.ui.workbench.lifecycle.ProcessAdditions;

import net.openchrom.rcp.ui.icons.handler.IconStreamHandlerService;

@SuppressWarnings("restriction")
public class ApplicationLifecycle {

	@ProcessAdditions
	public void processAdditions() {

		IconStreamHandlerService.getInstance().register();
	}
}
