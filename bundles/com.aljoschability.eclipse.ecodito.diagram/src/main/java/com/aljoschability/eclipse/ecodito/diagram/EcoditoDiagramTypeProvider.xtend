package com.aljoschability.eclipse.ecodito.diagram;

import com.aljoschability.eclipse.core.graphiti.editors.CoreDiagramTypeProvider

class EcoditoDiagramTypeProvider extends CoreDiagramTypeProvider {
	new() {
		featureProvider = new EcoditoFeatureProvider(this)
	}

	override protected createToolBehaviorProvider() {
		new EcoditoToolBehaviorProvider(this)
	}
}
