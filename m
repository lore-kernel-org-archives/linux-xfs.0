Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45CF27F37
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 23:46:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 32A878F8050
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 21:46:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Yp8iIodtqMX4yF1W (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 21:46:33 -0700 (PDT)
Date: Tue, 5 May 2015 21:46:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150506044633.GA30505@infradead.org>
References: <1430863299-9341-1-git-send-email-david@fromorbit.com>
	<1430863299-9341-2-git-send-email-david@fromorbit.com>
	<20150506043636.GA10940@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150506043636.GA10940@infradead.org>
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

On Tue, May 05, 2015 at 09:36:36PM -0700, Christoph Hellwig wrote:
> This looks reasonable, but I miss Ccs to the authors of the
> percpu_counter code and linux-kernel.

Ok, saw it on lkml.  Guess I need more coffee, sorry..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
