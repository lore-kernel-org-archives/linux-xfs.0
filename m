Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jan 2008 15:26:27 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0UNQIXi008275
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 15:26:24 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B09785821A0
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 15:26:40 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id G3CrFWqrudazO5Iq for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 15:26:40 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by enyo.dsw2k3.info (Postfix) with ESMTP id 5869D2BC53
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 00:26:38 +0100 (CET)
Received: from enyo.dsw2k3.info ([127.0.0.1])
	by localhost (enyo.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id X2ddSYNM4wgy for <xfs@oss.sgi.com>;
	Thu, 31 Jan 2008 00:26:33 +0100 (CET)
Received: from citd.de (p4FC4ED8B.dip.t-dialin.net [79.196.237.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by enyo.dsw2k3.info (Postfix) with ESMTP id 8C35B2BC47
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 00:26:32 +0100 (CET)
Date: Thu, 31 Jan 2008 00:26:28 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
Message-ID: <20080130232628.GA9671@citd.de>
References: <20080129093201.GA16203@citd.de> <20080129171658.GB21228@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129171658.GB21228@citd.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

A little followup.

Today i bought another 750GB HDD, and a 500GB.

Initializing the encryption of the 500GB finished a minute ago and the 
same bug, of course with a different size (357702MB), was observable.

Workaround also worked in this case (Now its 476937MB). This also proves 
that the bug is of recent nature, the last 500GB HDD i bought was just 
over a month ago and this bug didn't show up then.






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
