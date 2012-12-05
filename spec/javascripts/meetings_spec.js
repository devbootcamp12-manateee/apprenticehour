describe("Meetings", function() {

  describe("#validateField", function() {
    describe("When the value is empty", function() {
      var $field, result;
      beforeEach(function() {
        $field = affix('input#meeting_field]');
        $field.val('');
        result = Meeting.validateField($field);
      });

      it('returns false', function() {
        expect(result).toBeFalsy();
      });
      it('gives it a placeholder text based on the fields id', function() {
        expect($field.attr('placeholder')).toMatch(/field/);
      });
      it('adds the inputError class', function() {
      });
    });
  });
});