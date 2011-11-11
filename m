Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pABKTdIu222027 for <xfs@oss.sgi.com>; Fri, 11 Nov 2011 14:29:40 -0600
Message-ID: <1321043375.8773.50.camel@doink>
Subject: Re: [RFC PATCH 1/4] Define a new function xfs_this_quota_on()
From: Alex Elder <aelder@sgi.com>
Date: Fri, 11 Nov 2011 14:29:35 -0600
In-Reply-To: <20111027220529.2638.41757.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111027220529.2638.41757.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-10-27 at 17:05 -0500, Chandra Seetharaman wrote:
> Create a new function xfs_this_quota_on() that takes a xfs_mount
> data srtucture and a disk quota type and returns true if the specified
> type of quota is ON in the xfs_mount data structure.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
