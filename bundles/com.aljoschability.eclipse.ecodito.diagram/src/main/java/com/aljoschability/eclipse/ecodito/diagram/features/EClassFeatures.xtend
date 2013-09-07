package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EClassExtensions
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.features.impl.AbstractAddFeature
import org.eclipse.graphiti.features.impl.AbstractLayoutFeature
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.features.impl.Reason
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EClassCreateFeature extends CoreCreateFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Class"
		description = "Create Class"
		imageId = identifier
		largeImageId = identifier
	}

	override canCreate(ICreateContext context) {
		context.EPackage != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEClass
		element.name = context.EPackage.nextEClassifierName("Class")

		context.EPackage.EClassifiers += element

		return element
	}
}

class EClassAddFeature extends AbstractAddFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE
	extension AddService = AddService::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		context.container.addContainerShape [
			link = context.newObject
			addChopboxAnchor
			newRoundedRectangle[
				position = context.position
				size = context.size(200, 100)
				style = diagram.getShapeStyle
				radius = 6
				newImage[ // class symbol
					id = identifier
					position = #[7, 7]
					size = #[16, 16]
				]
				newText[ // class name
					position = #[27, 5]
					width = parentGraphicsAlgorithm.width - 54
					height = 20
					style = diagram.textStyle
					value = context.EClass.name
				]
				newPolyline[ // name separator
					newPoint(0, 29)
					newPoint(parentGraphicsAlgorithm.width, 29)
					style = diagram.getShapeStyle
				]
				newPolyline[ // attribute separator
					newPoint(0, 39)
					newPoint(parentGraphicsAlgorithm.width, 39)
					style = diagram.getShapeStyle
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.newObject instanceof EClass && context.EPackage != null
	}
}

class EClassLayoutFeature extends AbstractLayoutFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EClass != null
	}

	override layout(ILayoutContext context) {
		false
	}
}

class EClassUpdateFeature extends AbstractUpdateFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EClass != null
	}

	override updateNeeded(IUpdateContext context) {
		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		false
	}
}
