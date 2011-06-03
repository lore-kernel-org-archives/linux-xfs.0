Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53FRdjY018255 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 10:27:40 -0500
Subject: Re: [PATCH] xfstests: fix hardcoded path in output of 254
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1307109162-21811-1-git-send-email-dsterba@suse.cz>
References: <1307109162-21811-1-git-send-email-dsterba@suse.cz>
Date: Fri, 3 Jun 2011 10:27:36 -0500
Message-ID: <1307114856.2886.27.camel@doink>
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
To: David Sterba <dsterba@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, josef@redhat.com, xfs@oss.sgi.com

On Fri, 2011-06-03 at 15:52 +0200, David Sterba wrote:
> Add filters after btrfs commands, else the test would incorrectly appear
> failed.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Looks good.  I will commit this for you.

Signed-off-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
