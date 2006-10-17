Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 07:24:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9HEORaG010670
	for <linux-xfs@oss.sgi.com>; Tue, 17 Oct 2006 07:24:29 -0700
Received: from mondschein.lichtvoll.de (mondschein.lichtschiff.de [194.150.191.238])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F1BFD1998A6
	for <linux-xfs@oss.sgi.com>; Tue, 17 Oct 2006 06:19:01 -0700 (PDT)
Received: from deepdance.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 71E5CF9FB1
	for <linux-xfs@oss.sgi.com>; Tue, 17 Oct 2006 15:17:10 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: FS corruption and repair problem
Date: Tue, 17 Oct 2006 15:18:55 +0200
References: <20061016082532.GA5574@jdc> <20061017053514.GA5095@jdc> <200610170937.31036.Martin@lichtvoll.de>
In-Reply-To: <200610170937.31036.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610171518.55730.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 17 Oktober 2006 09:37 schrieb Martin Steigerwald:

> or tail -f /var/log/messages and mount it again. If XFS can't do write
> barriers on your machine, it should put an error message into log. You
> can find more about this is in the approbiate log entry.

Sorry, XFS faq entry that is...

-- 
Martin
