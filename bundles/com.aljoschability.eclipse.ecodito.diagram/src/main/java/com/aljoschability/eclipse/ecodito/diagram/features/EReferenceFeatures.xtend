package com.aljoschability.eclipse.ecodito.diagram.features

import com.aljoschability.eclipse.core.graphiti.features.CoreAddConnectionFeature
import com.aljoschability.eclipse.core.graphiti.features.CoreCreateConnectionFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EReferenceExtensions
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddConnectionContext
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateConnectionContext
import org.eclipse.graphiti.features.context.IReconnectionContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.features.context.impl.ReconnectionContext
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.features.impl.DefaultReconnectionFeature
import org.eclipse.graphiti.features.impl.Reason
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EReferenceCreateFeature extends CoreCreateConnectionFeature {
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Reference"
		description = "Create Reference"
		imageId = identifier
		largeImageId = identifier

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
		element.EType = context.targetEClass

		context.sourceEClass.EStructuralFeatures += element

		return element
	}
}

class EReferenceAddFeature extends CoreAddConnectionFeature {
	extension AddService = AddService::INSTANCE
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		diagram.addFreeFormConnection [
			start = context.sourceAnchor
			end = context.targetAnchor
			link = context.newObject
			addPolyline[
				style = diagram.connectionStyle
			]
		]
	}

	override canAdd(IAddContext context) {
		if (context instanceof IAddConnectionContext) {
			context.EReference != null
		} else {
			false
		}
	}
}

class EReferenceReconnectFeature extends DefaultReconnectionFeature {
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canStartReconnect(IReconnectionContext context) {
		context.EReference != null
	}

	override canReconnect(IReconnectionContext context) {
		return context.EReference != null && context.newEClass != null
	}

	override postReconnect(IReconnectionContext context) {
		switch context.reconnectType {
			case ReconnectionContext::RECONNECT_SOURCE: {
				context.newEClass.EStructuralFeatures += context.EReference
			}
			case ReconnectionContext::RECONNECT_TARGET: {
				context.EReference.EType = context.newEClass
			}
		}
	}
}

class EReferenceUpdateFeature extends AbstractUpdateFeature {
	extension EReferenceExtensions = EReferenceExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EReference != null
	}

	override updateNeeded(IUpdateContext context) {
		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
