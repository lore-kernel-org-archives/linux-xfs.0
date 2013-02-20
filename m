Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8044A7F50
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 14:17:38 -0600 (CST)
Date: Wed, 20 Feb 2013 14:17:35 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfstests: Provide dumpe2fs via standard
	common.config interface
Message-ID: <20130220201734.GS22182@sgi.com>
References: <1359886798-8818-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359886798-8818-1-git-send-email-tracek@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Sun, Feb 03, 2013 at 11:19:56AM +0100, Tomas Racek wrote:
> dumpe2fs can be now accessed via $DUMPE2FS_PROG, tests that require it
> can check for its availability by _require_dumpe2fs function.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Looks fine. 

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
