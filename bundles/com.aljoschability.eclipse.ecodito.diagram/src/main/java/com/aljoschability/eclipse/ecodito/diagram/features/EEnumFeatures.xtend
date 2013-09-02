package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.pattern.config.IPatternConfiguration

class EEnumCreateFeature extends CoreCreateFeature {
	new(IFeatureProvider fp) {
		super(fp)

		name = "EEnum"
		description = "Create EEnum"
		imageId = EEnum.simpleName
		largeImageId = EEnum.simpleName

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.targetContainer.businessObjectForPictogramElement instanceof EPackage
	}

	override createElement(ICreateContext context) {
		val p = context.targetContainer.businessObjectForPictogramElement as EPackage

		val element = EcoreFactory::eINSTANCE.createEEnum
		p.EClassifiers += element

		return element
	}
}

class EEnumPattern extends CorePattern {
	new(IPatternConfiguration patternConfiguration) {
		super();
	}

	override canCreate(ICreateContext context) {
		val pe = context.getTargetContainer();
		return getBO(pe) instanceof EPackage;
	}

	override protected isBO(Object bo) {
		return bo instanceof EDataType;
	}

	override protected getEClass() {
		return EcorePackage.Literals.EENUM;
	}
}
