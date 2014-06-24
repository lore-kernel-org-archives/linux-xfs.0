Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66FFB7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 18:41:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D32E304059
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 16:41:11 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18]) by cuda.sgi.com
	with ESMTP id dccDJUqYnCGoqCt9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 16:41:10 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-f85d3342-9468-4b09-8aec-5c4c3c380774-1403653268869@3capp-gmx-bs71>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Wed, 25 Jun 2014 01:41:08 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1241056612678581132=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1241056612678581132==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
<pre>Hi,
actually the backup is running but i run this command yesterday and i remember the result. It passes step1-3 without errors and left step 4-6. I cann run it later again if this doesnt fit to you.

On 6/24/2014 5:15 PM, Dragon wrote:
</pre>

<blockquote>Hi, yes read this, but i am new and dont know what this command will do and i dont want to lost my data. I read in the net, that some people couldnt start or boot from that disk, after running xfs_repair. I looked for a upgrade to latest xfsprogs version, but it seems difficult for amd64 systems. Do you have a changelog to latest version, could my installed version be ok, or better not to use? Thx Stan and Eric</blockquote>
# xfs_repair -n -P /dev/device Post the output in your next reply, assuming it doesn&#39;t hang again. Cheers, Stan</div></div></body></html>


--===============1241056612678581132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1241056612678581132==--
