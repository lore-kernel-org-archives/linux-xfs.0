Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3B8729DF8
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 11:09:10 -0500 (CDT)
Message-ID: <5183E12D.6070706@sgi.com>
Date: Fri, 3 May 2013 11:09:17 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
In-Reply-To: <51827DDF.4050708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs-oss <xfs@oss.sgi.com>

Thanks Eric, this patch has been committeed.

--Rich

commit 120752942a542742a32aafa2cd5d247f3e0d1479
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu May 2 14:53:19 2013 +0000

     xfstests: fix internal _xfs_check to handle logdev etc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
