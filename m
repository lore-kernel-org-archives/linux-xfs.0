Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KG8Jah048492 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 11:08:20 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D605015442E0
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 09:10:18 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id a4x4QY7m8NoDJnVy for
	<xfs@oss.sgi.com>; Tue, 20 Apr 2010 09:10:18 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3KGADdl010594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 16:10:15 GMT
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by rcsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3KES0OP029671 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 16:10:12 GMT
Date: Wed, 21 Apr 2010 00:09:06 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: do we support using a file as logdev?
Message-ID: <20100420160906.GC3634@laptop.oracle.com>
References: <20100420143656.GA3634@laptop.oracle.com>
	<20100420152706.GA4548@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420152706.GA4548@teal.hq.k1024.org>
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
To: Wengang Wang <wen.gang.wang@oracle.com>, xfs@oss.sgi.com, greg.marsden@oracle.com, joe.jin@oracle.com

On 10-04-20 17:27, Iustin Pop wrote:
> On Tue, Apr 20, 2010 at 10:36:56PM +0800, Wengang Wang wrote:
> > Hi experts,
> > 
> > Do we support using a file as log device?
> > If no, it's strange that we support running xfs on a file but don't support log
> > file.
> 
> Have you tried using losetup and passing the loop device instead?

Yes, that's a workaround.

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
