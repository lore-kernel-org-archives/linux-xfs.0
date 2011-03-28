Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SIogTu179177 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 13:50:42 -0500
Subject: Re: [PATCH] xfs: cleanup duplicate initializations
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1301332373-24914-1-git-send-email-dsterba@suse.cz>
References: <1301332373-24914-1-git-send-email-dsterba@suse.cz>
Date: Mon, 28 Mar 2011 13:52:50 -0500
Message-ID: <1301338370.2622.10.camel@doink>
Mime-Version: 1.0
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Mon, 2011-03-28 at 19:12 +0200, David Sterba wrote:
> follow these guidelines:
> - leave initialization in the declaration block if it fits the line
> - move to the code where it's more suitable ('for' init block)
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
