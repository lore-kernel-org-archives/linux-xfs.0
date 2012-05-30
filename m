Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4UM3Qr7067489 for <xfs@oss.sgi.com>; Wed, 30 May 2012 17:03:26 -0500
Date: Wed, 30 May 2012 17:09:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs: blocked task in xfs_buf_lock
Message-ID: <20120530220914.GF4721@sgi.com>
References: <4FBE1823.2050303@profihost.ag>
 <4FC272D0.4090101@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FC272D0.4090101@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, gregkh@linuxfoundation.org, stable@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Stefan, 

On Sun, May 27, 2012 at 08:30:40PM +0200, Stefan Priebe wrote:
> nobody who has an idea? Or what to check?

I think we need more information to get anywhere.  Maybe 'echo t >
/proc/sysrq-trigger' is a good place to start?

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
