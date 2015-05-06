Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDF4B7F37
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 23:36:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5AA8FAC002
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 21:36:38 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dw0EycHU0X09FZha (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 21:36:36 -0700 (PDT)
Date: Tue, 5 May 2015 21:36:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150506043636.GA10940@infradead.org>
References: <1430863299-9341-1-git-send-email-david@fromorbit.com>
	<1430863299-9341-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430863299-9341-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

This looks reasonable, but I miss Ccs to the authors of the
percpu_counter code and linux-kernel.

On Wed, May 06, 2015 at 08:01:38AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> From: Dave Chinner <dchinner@redhat.com>

And this looks wrong, too :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
