Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QGEsQw019285 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 11:14:54 -0500
Message-ID: <1319645667.5239.20.camel@doink>
Subject: Re: [RFC PATCH 3/3] Add pquotaino to on-disk super block
From: Alex Elder <aelder@sgi.com>
Date: Wed, 26 Oct 2011 11:14:27 -0500
In-Reply-To: <20111018000949.14942.51030.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111018000949.14942.51030.sendpatchset@chandra-lucid.austin.ibm.com>
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

On Mon, 2011-10-17 at 19:09 -0500, Chandra Seetharaman wrote:
> Add a new field to the superblock to add support for seperate pquota
> with a specific version.
> 
> No change made yet to gather both project and group quota with quotactl.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Since you have already indicated you're going to
re-post this series after a bit of rework, I'm
not going to review this patch (or patch 2/3).
I'll wait for the next edition.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
