Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAECm2MR210183 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 06:48:02 -0600
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D1E71E9B532
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 04:48:01 -0800 (PST)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id yHh9LJ8616Tm3gn4 for
	<xfs@oss.sgi.com>; Mon, 14 Nov 2011 04:48:01 -0800 (PST)
Message-ID: <4EC10DE8.6030607@oracle.com>
Date: Mon, 14 Nov 2011 20:47:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: SEEK_DATA/SEEK_HOLE support
References: <4E887D7F.2010306@oracle.com>
	<20111114102444.GA27791@infradead.org>
In-Reply-To: <20111114102444.GA27791@infradead.org>
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

On 11/14/2011 06:24 PM, Christoph Hellwig wrote:

> Just curious:  did you start looking into implementing
> SEEK_DATA/SEEK_HOLE support?

I have misunderstood your previous response:

"Dave mentioned he had a basic implementation, he might have some code
that you can improve on.=94

So I am still waiting that now.

But actually I have already wrote a patch at that time, I'll run a few
tests and send it out for your guys review soon.

Thanks,
-Jeff

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
