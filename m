Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CMKsU7038064
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 16:20:57 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E5B51CC9392
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:22:09 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id l55GbK2q5htCASzH for <linux-xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 14:22:09 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Ng3tn-0007rv-9S
	for linux-xfs@oss.sgi.com; Fri, 12 Feb 2010 23:22:07 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 23:22:07 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 23:22:07 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
Date: Fri, 12 Feb 2010 17:21:47 -0500
Message-ID: <hl4k9p$76o$1@ger.gmane.org>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>	<hl438l$bhm$1@ger.gmane.org>
	<4B7594D3.6040304@sandeen.net>	<hl45te$kjs$1@ger.gmane.org>
	<hl4dpt$fq2$1@ger.gmane.org>
	<2d460de71002121239y42ec9671id5e147e9709e42ac@mail.gmail.com>
Mime-Version: 1.0
In-Reply-To: <2d460de71002121239y42ec9671id5e147e9709e42ac@mail.gmail.com>
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
To: linux-xfs@oss.sgi.com

On 2/12/10 3:39 PM, Richard Hartmann wrote:
> On Fri, Feb 12, 2010 at 21:30, Nicolas Stransky <nico@stransky.cx> wrote:
>> The -P option allowed me to complete xfs_repair successfully, but it
>> also deleted almost everything on the filesystem... A directory that I
>> could mount -o ro,norecovery before, with tens of GB of data in it, is
>> now empty... That is really too bad.
> 
> Do you still have a backup of the raw disk?

Unfortunately I don't. I think it's just lost now.

-- 
Nico

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
