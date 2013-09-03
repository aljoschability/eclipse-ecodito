package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateConnectionFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EReferenceExtensions
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.ICreateConnectionContext

class EReferenceCreateFeature extends CoreCreateConnectionFeature {
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Reference"
		description = "Create Reference"
		imageId = icon
		largeImageId = icon

		editable = true
	}

	override canStartConnection(ICreateConnectionContext context) {
		context.sourceEClass != null
	}

	override canCreate(ICreateConnectionContext context) {
		context.sourceEClass != null && context.targetEClass != null
	}

	override create(ICreateConnectionContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
