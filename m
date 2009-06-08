Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58KDvO2247642
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jun 2009 15:13:57 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69FD48A92FD
	for <linux-xfs@oss.sgi.com>; Mon,  8 Jun 2009 13:21:16 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id LDpJr9T9x0V3J1rp for
	<linux-xfs@oss.sgi.com>; Mon, 08 Jun 2009 13:21:16 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n58KDJjV005075
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jun 2009 22:13:20 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n58KDJI29720 for linux-xfs@oss.sgi.com;
	Mon, 8 Jun 2009 22:13:19 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Mon, 8 Jun 2009 20:13:18 +0000 (UTC)
Message-ID: <h0jrcu$tkc$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<h0hbb2$1358$1@osprey.mgras.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Martin Spott wrote:
> Christoph Hellwig wrote:
> 
>> I recently started auditing the code and started to fix some locking
>> issues in there, could you give the patch below a try?
> 
>  http://foxtrot.mgras.net/static/messages-20090607.2.bz2
> 
> I'm sorry but I'll have to boot the system using the previous kernel,

Next 'maintenance window'  ;-)  starts wednesday evening. Please advise
if you'd like me to perform further tests,

	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
