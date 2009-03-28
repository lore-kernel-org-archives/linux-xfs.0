Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2SEt7pd066674 for <xfs@oss.sgi.com>; Sat, 28 Mar 2009 09:55:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C47CC13D6E8E
	for <xfs@oss.sgi.com>; Sat, 28 Mar 2009 07:54:53 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id gJ3GpVjJgM1WJ3qm for
	<xfs@oss.sgi.com>; Sat, 28 Mar 2009 07:54:53 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id C3331AC627C
	for <xfs@oss.sgi.com>; Sat, 28 Mar 2009 09:54:18 -0500 (CDT)
Message-ID: <49CE3A1A.9020103@sandeen.net>
Date: Sat, 28 Mar 2009 09:54:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfstests license clarification?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Since most of the scripts themselves in xfstests make no mention of
redistribution, and only say "copyright sgi, all rights reserved" etc:

#-----------------------------------------------------------------------
#  Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
#-----------------------------------------------------------------------

do we need to do anything in terms of making this look more like Free
Software (assuming that's the intent?)

It might be a rats-nest, there are a several testcases in src/ gleaned
from mailing lists & bugs with little or no attribution; OTOH maybe this
stuff is trivial enough that it doesn't warrant copyright, I dunno.

Is it worth trying to clarify the license on the collection, or is this
just a can of worms?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
