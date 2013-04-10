Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F147B29DFE
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 07:13:45 -0500 (CDT)
Message-ID: <51655796.8000701@sgi.com>
Date: Wed, 10 Apr 2013 07:14:14 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: replace $seq.full with $seqres.full in
	ext4/305 and generic/308
References: <1365331147-15179-1-git-send-email-eguan@redhat.com>
	<1365331147-15179-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1365331147-15179-2-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

Eryu,

Thanks for the patch, it has been committed.

--Rich

commit 2bfce6d36f9fb1cba6a0c677a82c08a6f305db62
Author: Eryu Guan <eguan@redhat.com>
Date:   Sun Apr 7 10:39:06 2013 +0000

     xfstests: replace $seq.full with $seqres.full in ext4/305 and 
generic/308


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
