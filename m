Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 06:15:52 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0AEFkqw006747
	for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 06:15:48 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1H4eE2-00049Y-Hp
	for linux-xfs@oss.sgi.com; Wed, 10 Jan 2007 15:14:46 +0100
Received: from p54a57214.dip.t-dialin.net ([84.165.114.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 15:14:46 +0100
Received: from christoph.bier by p54a57214.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 15:14:46 +0100
From: Christoph Bier <christoph.bier@web.de>
Subject: Re: Mounting an external HDD fails each second time after xfs_repair
Date: Wed, 10 Jan 2007 15:14:35 +0100
Message-ID: <eo2scb$q4h$1@sea.gmane.org>
References: <eo2q35$h6e$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: <eo2q35$h6e$1@sea.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Christoph Bier schrieb am 10.01.2007 14:35:

[...]

> I didn't change anything else after the mount failure mentioned
> above! BUT: Reading fails while I wanted to have a look at the files
> in lost+found.
> [/var/log/syslog output:
> http://www.zvisionwelt.de/tmpdownloads/read-failure-syslog.output]

Only files in lost+found seem to be affected. I successfully opened
some others files.

[...]
-- 
+++ Typografie-Regeln: http://zvisionwelt.de/downloads.html (1.6)
