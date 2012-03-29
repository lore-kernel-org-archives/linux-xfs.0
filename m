Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TANBsO073280 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 05:23:12 -0500
Received: from mx.nrchpc.ac.cn ([221.122.61.228]) by cuda.sgi.com with ESMTP
	id SJPGXPvBvUgHV9Y5 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 03:23:08 -0700 (PDT)
Received: from liuyumsPC ([221.122.61.228]) (authenticated bits=0)
	by mx.nrchpc.ac.cn (8.13.8/8.13.8) with ESMTP id q2TAOjKT023452
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 18:24:45 +0800
From: "Liu Yu" <liuyums@bwstor.com.cn>
Subject: xfstests: 066: why stat dir but not largefile?
Date: Thu, 29 Mar 2012 18:23:05 +0800
Message-ID: <007e01cd0d95$ee7537c0$cb5fa740$@com.cn>
MIME-Version: 1.0
Content-Language: zh-cn
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
To: xfs@oss.sgi.com

Hi folks,

If we indeed want to stat dir, then what do we create a largefile for?

Thanks,
Yu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
