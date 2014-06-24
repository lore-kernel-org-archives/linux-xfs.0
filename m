Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1C577F53
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:08:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14964AC005
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:07:58 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20]) by cuda.sgi.com
	with ESMTP id mtPkGWiE5TlcJk2F (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 12:07:57 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-570f385d-1cb3-4677-8943-c2cefe73ffce-1403636875999@3capp-gmx-bs71>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Tue, 24 Jun 2014 21:07:56 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5572376405308291070=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5572376405308291070==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><pre>Hi Stan,
will check that. Is there any possebility to check a fresh or running xfs installation? I would check the fs and if all is ok i whould copy my files. xfs_check is depre. i heard ;).

On 6/24/2014 10:43 AM, Dragon wrote:
</pre>

<blockquote>Hi, ok will try. So what could be the problem of this? Maybe the lost of one disk out of raid6? I think not, or? Maybe a controller failure? Before i used ext4 and never had problems with this hardware...</blockquote>

<div>If it&#39;s a hardware problem there should be errors in dmesg. Cheers, Stan</div></div></body></html>


--===============5572376405308291070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5572376405308291070==--
