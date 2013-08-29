package com.aljoschability.eclipse.ecodito.properties.sections;

import com.aljoschability.eclipse.core.properties.State
import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import com.aljoschability.eclipse.core.properties.sections.AbstractTextSection
import com.aljoschability.eclipse.ecodito.GenmodelConstants
import org.eclipse.emf.common.command.Command
import org.eclipse.emf.common.command.CompoundCommand
import org.eclipse.emf.ecore.EAnnotation
import org.eclipse.emf.ecore.EModelElement
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.emf.ecore.impl.EStringToStringMapEntryImpl
import org.eclipse.emf.edit.command.AddCommand

public class EModelElementDocumentationSection extends AbstractTextSection {
	private boolean addAnnotation;
	private EAnnotation annotation;

	private boolean addEntry;
	private EStringToStringMapEntryImpl entry;

	new() {
		super(GraphitiElementAdapter.get());
	}

	override protected validate(String value) {
		return State.info("The comment describes the element.");
	}

	override protected execute(Command command) {
		val compoundCommand = new CompoundCommand();
		if (addAnnotation) {
			val owner = super.getElement();
			val feature = EcorePackage.Literals.EMODEL_ELEMENT__EANNOTATIONS;
			val annotationCommand = AddCommand.create(getEditingDomain(), owner, feature, annotation);
			compoundCommand.append(annotationCommand);
			addAnnotation = false;
		}

		if (addEntry) {
			val owner = annotation;
			val feature = EcorePackage.Literals.EANNOTATION__DETAILS;
			val entryCommand = AddCommand.create(getEditingDomain(), owner, feature, entry);
			compoundCommand.append(entryCommand);
			addEntry = false;
		}

		compoundCommand.append(command);

		super.execute(compoundCommand.unwrap());
	}

	override protected getElement() {
		val element = super.getElement();
		if (element instanceof EModelElement) {

			// annotation
			annotation = element.getEAnnotation(GenmodelConstants.SOURCE);
			if (annotation == null) {
				annotation = EcoreFactory.eINSTANCE.createEAnnotation();
				annotation.setSource(GenmodelConstants.SOURCE);
				addAnnotation = true;
			}

			// details entry
			val index = annotation.getDetails().indexOfKey(GenmodelConstants.KEY_DOCUMENTATION);
			if (index == -1) {
				val type = EcorePackage.Literals.ESTRING_TO_STRING_MAP_ENTRY;
				entry = EcoreFactory.eINSTANCE.create(type) as EStringToStringMapEntryImpl;
				entry.setKey(GenmodelConstants.KEY_DOCUMENTATION);
				entry.setValue(EMPTY);
				addEntry = true;
			} else {
				entry = annotation.getDetails().get(index) as EStringToStringMapEntryImpl;
			}

			return entry;
		}
		return null;
	}

	override protected getFeature() {
		return EcorePackage.Literals.ESTRING_TO_STRING_MAP_ENTRY__VALUE;
	}

	override protected String getLabelText() {
		return "Comment";
	}

	override protected isGroupWrapped() {
		return true;
	}

	override protected isMultiLine() {
		return true;
	}

	override protected isUsingMonospace() {
		return true;
	}
}
