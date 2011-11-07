Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7K4oDZ074446 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:04:50 -0600
Date: Mon, 7 Nov 2011 14:05:03 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH 0/4] Rearrange code to make the code more readable
Message-ID: <20111107200503.GH20464@sgi.com>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
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

Hey Chandra,

On Thu, Oct 27, 2011 at 05:05:23PM -0500, Chandra Seetharaman wrote:
> These are the split up patches from patch 1/5 that I posted today, as
> suggested by Christoph.
> 
> These define some new inline functions and macros, rearrange
> the code for easier reading, simplification of code paths
> and prepare for the changes to support pquota and gquota
> simultaneously.

All four of these patches look good to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
