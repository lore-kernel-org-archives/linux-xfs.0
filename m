Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o52CVsoq076886 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 07:31:55 -0500
Received: from chip.uscs.susx.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CECF1D5552B
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 05:34:19 -0700 (PDT)
Received: from chip.uscs.susx.ac.uk (chip.uscs.susx.ac.uk [139.184.14.86]) by
	cuda.sgi.com with ESMTP id JNeuXYgawO66AnKr for
	<xfs@oss.sgi.com>; Wed, 02 Jun 2010 05:34:19 -0700 (PDT)
Received: from pactbook.pact.cpes.susx.ac.uk ([139.184.130.15]:49919)
	by chip.uscs.susx.ac.uk with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.64) (envelope-from <a.asawaroengchai@sussex.ac.uk>)
	id L3E0EC-000LVM-26
	for xfs@oss.sgi.com; Wed, 02 Jun 2010 13:37:24 +0100
Message-ID: <4C064FC6.5050401@sussex.ac.uk>
Date: Wed, 02 Jun 2010 13:34:14 +0100
From: Albert Asawaroengchai <a.asawaroengchai@sussex.ac.uk>
MIME-Version: 1.0
Subject: xfs_quota timer
Content-Type: multipart/mixed; boundary="------------090309090803020002090605"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090309090803020002090605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I'm trying to set the timer for a filesystem, but I don't understand how
to use the syntax.

xfs_quota -x -c 'timer 1w user' /target/filesystem

The above doesn't seem to work, can anyone give advice or point me in
the right direction?

Many thanks,

Albert

--------------090309090803020002090605
Content-Type: text/x-vcard; charset=utf-8;
 name="a_asawaroengchai.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="a_asawaroengchai.vcf"

begin:vcard
fn:Albert Asawaroengchai
n:Asawaroengchai;Albert
org:University of Sussex;Physics and Astronomy
adr:;;;Brighton;East Sussex;BN1 9QH;United Kingdom
email;internet:a.asawaroengchai@sussex.ac.uk
title:UNIX System Administrator
tel;work:+44 (0)1273 873059
url:http://www.pact.cpes.susx.ac.uk/
version:2.1
end:vcard


--------------090309090803020002090605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090309090803020002090605--
