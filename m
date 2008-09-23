Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 00:58:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N7vxZv029979
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 00:58:00 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B66C946FC80
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 00:59:29 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id slF8WwVx1jPDtHAk for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 00:59:29 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Ki2ne-0008Ar-7R
	for xfs@oss.sgi.com; Tue, 23 Sep 2008 17:59:10 +1000
Date: Tue, 23 Sep 2008 17:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC 0/3] Future Directions for XFS....
Message-ID: <20080923075910.GA5448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Folks,

I'm about to post a set of three documents that I was in the process
of writing while working on contract for Agami Systems.  I have
managed to get them extracted from the corpse of Agami so that the
concepts and thoughts are not lost.

The documents encompass three different areas of interest - the
inode subsystem, journalling and reliability - and try to encompass
all the concepts and ideas that had either been used to solve
problems or were considered the way forward to solve further issues
that were being seen.

I'm hoping that these documents will go a long way to defining the
future direction and development plan for the XFS community.  At
minimum I am hoping that these documents will foster an amount of
discussion and provide tasks for anyone who wants to contribute to
XFS.

I intend to keep the documents up to date according to the
discussion that occurs so that they can form reference documentation
when it comes to implementing various features. Suggestions on the
best place to host these documents are welcome....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
