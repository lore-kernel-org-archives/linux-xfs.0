Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDF1D7FE9
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:48:00 -0600 (CST)
Date: Thu, 7 Mar 2013 12:48:00 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH -v3 12/23] xfs: rename random32() to prandom_u32()
Message-ID: <20130307184800.GW30652@sgi.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
	<1362401911-14074-13-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1362401911-14074-13-git-send-email-akinobu.mita@gmail.com>
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
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Akinobu,

On Mon, Mar 04, 2013 at 09:58:20PM +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: <bpm@sgi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

Applied this to git://oss.sgi.com/xfs/xfs.git, master branch.

Thanks!
-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
