package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EEnumExtensions
import org.eclipse.emf.ecore.EPackage
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

class EEnumCreateFeature extends CoreCreateFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Enumeration"
		description = "Create Enumeration"
		imageId = icon
		largeImageId = icon

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.targetContainer.businessObjectForPictogramElement instanceof EPackage
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEEnum
		element.name = context.EPackage.nextName("Enumeration")

		context.EPackage.EClassifiers += element

		return element
	}
}

class EEnumAddFeature extends AbstractAddFeature {
	extension AddService = AddService::INSTANCE
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		context.container.addContainerShape [
			link = context.newObject
			val frame = newRoundedRectangle[
				position = context.position
				size = context.size(200, 100)
				radius = 6
				style = diagram.getShapeStyle
				val titleSymbol = newImage[
					position = #[7, 7]
					size = #[16, 16]
					id = icon
				]
				val titleText = newText[
					position = #[27, 5]
					width = parentGraphicsAlgorithm.width - 54
					height = 20
					style = diagram.getTextStyle
					value = context.EEnum.name
				]
				val titleSeparator = newPolyline[
					newPoint(0, 29)
					newPoint(parentGraphicsAlgorithm.width, 29)
					style = diagram.getShapeStyle
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EPackage != null && context.EEnum != null
	}
}

class EEnumLayoutFeature extends AbstractLayoutFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EEnum != null
	}

	override layout(ILayoutContext context) {
		false
	}
}

class EEnumUpdateFeature extends AbstractUpdateFeature {
	extension EEnumExtensions = EEnumExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EEnum != null
	}

	override updateNeeded(IUpdateContext context) {
		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		false
	}
}
