Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pABKTkjr222050 for <xfs@oss.sgi.com>; Fri, 11 Nov 2011 14:29:46 -0600
Message-ID: <1321043381.8773.51.camel@doink>
Subject: Re: [RFC PATCH 2/4] Define a new function xfs_inode_dquot()
From: Alex Elder <aelder@sgi.com>
Date: Fri, 11 Nov 2011 14:29:41 -0600
In-Reply-To: <20111027220534.2638.54570.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111027220534.2638.54570.sendpatchset@chandra-lucid.austin.ibm.com>
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
> Define a new function xfs_inode_dquot() that takes a inode pointer
> and a disk quota type and returns the quota pointer for the specified
> quota type.
> 
> This simplifies the xfs_qm_dqget() error path significantly.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
