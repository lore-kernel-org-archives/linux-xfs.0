Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD70E7F9D
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 15:44:05 -0500 (CDT)
Message-ID: <5212838F.7030001@sgi.com>
Date: Mon, 19 Aug 2013 15:43:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/009 never shrinked or removed $seqres.full
References: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Thanks for the patch Stefan, it has been committed.

--Rich

commit 6bd8df93fa6b7d9ce402f9c665e5971106df7843
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 16 17:44:54 2013 +0000

     xfstests: btrfs/009 never shrinked or removed $seqres.full

     Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
