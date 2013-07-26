Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3CB17F4E
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 06:51:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 913FE8F8033
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 04:51:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LxQbgibHKLghwHB5 for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 04:51:57 -0700 (PDT)
Date: Fri, 26 Jul 2013 21:51:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V8 27/33] xfs: add support for read_iter and write_iter
Message-ID: <20130726115136.GP13468@dastard>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<1374774659-13121-28-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374774659-13121-28-git-send-email-dave.kleikamp@oracle.com>
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
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>, "Maxim V. Patlasov" <mpatlasov@parallels.com>

On Thu, Jul 25, 2013 at 12:50:53PM -0500, Dave Kleikamp wrote:
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

Looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
