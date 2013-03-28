Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 064E57CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 16:07:39 -0500 (CDT)
Message-ID: <5154B11F.1080101@sgi.com>
Date: Thu, 28 Mar 2013 16:07:43 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: check: set up config variables before using them
References: <1364490018-30520-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1364490018-30520-1-git-send-email-dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

David,

Thanks again for the patch it has been committed.

--Rich

commit 2c13db28be33d71f6acff080f93893c739ee91e3
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Mar 28 17:00:18 2013 +0000

     xfstests: check: set up config variables before using them

     HOSTOS was used in a test before being initialized and this led to
     failed filesystem type detection.

     Signed-off-by: David Sterba <dsterba@suse.cz>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
