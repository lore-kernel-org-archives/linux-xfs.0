Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29C437CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 10:31:21 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 137278F8065
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 08:31:18 -0700 (PDT)
Received: from [128.162.232.11] (porter.americas.sgi.com [128.162.232.11])
	by estes.americas.sgi.com (Postfix) with ESMTP id E31E47002927
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 10:31:17 -0500 (CDT)
Message-ID: <51ACB6C5.8010400@sgi.com>
Date: Mon, 03 Jun 2013 10:31:17 -0500
From: Troy McCorkell <tdm@sgi.com>
MIME-Version: 1.0
Subject: Re: Debunking myths about metadata CRC overhead
References: <20130603074452.GZ29466@dastard>
In-Reply-To: <20130603074452.GZ29466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 06/03/2013 02:44 AM, Dave Chinner wrote:
> Hi folks,
>
> There has been some assertions made recently that metadata CRCs have
> too much overhead to always be enabled.  So I'll run some quick
> benchmarks to demonstrate the "too much overhead" assertions are
> completely unfounded.
>
>
>    
Dave,

Thanks for generating, gathering, and providing this data.

Thanks,
Troy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
