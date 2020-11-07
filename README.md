[![License: BSD](https://badgen.net/badge/license/BSD/orange)](https://opensource.org/licenses/BSD-3-Clause)
# MySQL DDL

<p align="center">
Sample Database Schema DDL 🐒 Multi-tenant SaaS
</p>
```ruby
CREATE TABLE IF NOT EXISTS `email_tmpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `email_tmpl_nm` varchar(32) NOT NULL COMMENT 'Email Template Name',
  `email_tmpl_desc` varchar(176) DEFAULT NULL COMMENT 'Email Template Description',
  `subject_text` varchar(96) DEFAULT NULL COMMENT 'Subject of Message (Token Pattern)',
  `from_address` varchar(32) NOT NULL COMMENT 'From email address',
  `from_nm` varchar(32) NOT NULL COMMENT 'From Name',
  `body_markup` blob COMMENT 'Message Rich Text (Token Pattern)',
  `body_text` blob NOT NULL COMMENT 'Message Plain Text (Token Pattern)',
  `attachment_1` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  `attachment_2` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
```
#
[Portfolio Blog](https://www.theScottKrause.com) |
[🚀 Résumé](https://thescottkrause.com/Arcanus_Scott_C_Krause_2020.pdf) |
[NPM](https://www.npmjs.com/~neodigm) |
[Github](https://github.com/neodigm) |
[LinkedIn](https://www.linkedin.com/in/neodigm24/) |
[Gists](https://gist.github.com/neodigm?direction=asc&sort=created) |
[Salesforce](https://trailblazer.me/id/skrause) |
[Code Pen](https://codepen.io/neodigm24) |
[Machvive](https://machvive.com/) |
[Arcanus 55](https://www.arcanus55.com/) |
[Repl](https://repl.it/@neodigm) |
[Twitter](https://twitter.com/neodigm24) |
[Keybase](https://keybase.io/neodigm) |
[Docker](https://hub.docker.com/u/neodigm) |
[W3C](https://www.w3.org/users/123844)
#
---
<p align="center">
  <a target="_blank" href="https://thescottkrause.com/d3_datavis_skills.html">
  <img src="https://repository-images.githubusercontent.com/178555357/2b6ad880-7aa0-11ea-8dde-63e70187e3e9" title="D3js Skills with Audio">
  </a>
</p>
