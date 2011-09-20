Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KFbera068335 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:37:40 -0500
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
Date: Tue, 20 Sep 2011 10:37:36 -0500
Message-ID: <1316533056.2912.19.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: sekharan@us.ibm.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-09-20 at 08:56 -0500, Chandra Seetharaman wrote:
> Ran the xfstests (auto) overnight and didn't see any new issues.
> 
> --
> Check the return value of xfs_trans_get_buf() and fail appropriately.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
