Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 22:01:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7K51Qbm002661
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 22:01:27 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 5FD7118DF93BB
	for <xfs@oss.sgi.com>; Mon, 20 Aug 2007 00:01:32 -0500 (CDT)
Message-ID: <46C92035.6040504@sandeen.net>
Date: Mon, 20 Aug 2007 00:01:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: upstream changes missing from cvs?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Hi sgi folks -

Noticed that upstream calls to generic_segment_checks() in xfs_lrw.c
seem to be missing from cvs/ptools.  Was this on purpose or are changes
pushed directly to upstream getting lost in cvs?

-Eric
