Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 17:56:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C0uqA3029388
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 17:56:54 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3695A124E8FC
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 17:58:09 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 5QIWvrheYJ9EDUCm for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 17:58:09 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KSiD0-00068E-Uu
	for xfs@oss.sgi.com; Tue, 12 Aug 2008 10:57:58 +1000
Date: Tue, 12 Aug 2008 10:57:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: commit messages wrong in XFS git -master tree....
Message-ID: <20080812005758.GJ6119@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

SGI folks,

The commit messages for a couple of patches has been screwed
up. The patch series I sent titled:

[PATCH 1/3] XFS: Avoid directly referencing the VFS inode
[PATCH 2/3] XFS: kill shouty XFS_ITOV_NULL macro
[PATCH 3/3] XFS: Kill shouty XFS_ITOV() macro

Is the one that I've noticed. Patch 2/3 has the commit message
for patch 1/3 instead of the correct one. Patch 1/3 has a corrupt
version of it's commit message.

Can someone please fix this up?

And can ppl be more careful when committing patches in future
and make sure they get the commit messages correct?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
