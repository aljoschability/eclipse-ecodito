package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreAddConnectionFeature
import com.aljoschability.eclipse.core.graphiti.features.CoreCreateConnectionFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EReferenceExtensions
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.ICreateConnectionContext
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IAddConnectionContext
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.util.IColorConstant
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.features.context.IUpdateContext

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

	override createElement(ICreateConnectionContext context) {
		val element = EcoreFactory::eINSTANCE.createEReference

		context.sourceEClass.EStructuralFeatures += element

		element.EType = context.targetEClass

		return element
	}
}

class EReferenceAddFeature extends CoreAddConnectionFeature {
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		val connection = Graphiti::peService.createFreeFormConnection(getDiagram())
		connection.start = context.sourceAnchor
		connection.end = context.targetAnchor

		// create link and wire it
		link(connection, context.EReference)

		val polyline = Graphiti::gaService.createPolyline(connection)
		polyline.lineWidth = 2
		polyline.foreground = IColorConstant::RED

		return connection
	}

	override canAdd(IAddContext context) {
		if (context instanceof IAddConnectionContext) {
			context.EReference != null
		} else {
			false
		}
	}
}

class EReferenceUpdateFeature extends AbstractUpdateFeature {
	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		false
	}

	override update(IUpdateContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override updateNeeded(IUpdateContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
