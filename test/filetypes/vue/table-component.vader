Given vue (table layout component with script, style and template elements):
  <template>
    <div>
      <button @click="increment">Increment</button>
      <p>Total Count: {{ count }}</p>
    </div>
  </template>

  <script>
  export default {
    data() {
      return {
        count: 0
      };
    },
    methods: {
      increment() {
        this.count++;
      }
    }
  };
  </script>

  <style scoped>
  </style>

Do (trigger doge):
  :10\<CR>
  \<C-d>
  :21\<CR>
  \<C-d>

Expect vue (generated comment with generated comment inside <script>):
  <template>
    <div>
      <button @click="increment">Increment</button>
      <p>Total Count: {{ count }}</p>
    </div>
  </template>

  <script>
  export default {
    /**
     * [TODO:description]
     *
     * @returns [TODO:description]
     */
    data() {
      return {
        count: 0
      };
    },
    methods: {
      /**
       * [TODO:description]
       *
       */
      increment() {
        this.count++;
      }
    }
  };
  </script>

  <style scoped>
  </style>
