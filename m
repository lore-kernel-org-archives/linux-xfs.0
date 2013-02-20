Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 661147F37
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 12:11:08 -0600 (CST)
Date: Wed, 20 Feb 2013 12:11:04 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v4] xfstests 297: test xfs direct IO nested transaction
	deadlock
Message-ID: <20130220181104.GR22182@sgi.com>
References: <1361247328-22175-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361247328-22175-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

Hi Eryu,

On Tue, Feb 19, 2013 at 12:15:28PM +0800, Eryu Guan wrote:
> Regression test case for commit:
> 
> 437a255 xfs: fix direct IO nested transaction deadlock.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks good, works fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
