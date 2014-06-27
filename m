Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C8A8D7F9D
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 02:42:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 765A3AC001
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 00:42:56 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18]) by cuda.sgi.com
	with ESMTP id FYyb5GH59Q19d8Vc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 00:42:54 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-77b248f2-e671-476c-9a73-f159dbaae892-1403854972775@3capp-gmx-bs65>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Fri, 27 Jun 2014 09:42:52 +0200
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
To: xfs@oss.sgi.com

Hello,
thanks for advises for the list - i changed to txt-format. Situation before xfs failure was that i had have a raid6 with 5 Disks. I copied alle files from one server to this, because the space on the other was full and have to rebuild.. After that i needed one more disk, which i didnt had, so i take 1 out of the raid6. Restart, check and all looks good. I dont know, because since that its aprox 4 weeks ago, when and whey the xfs failure occures, but as i wanted to copy all files back to the new server, i get this message from xfs to repair the file structure. I searched a lot, was in xfs irc, where no one could/whould help so i finally wrote to this list. While a lot time past and i need those server i yesterday reboot from live-cd and backup the most of it. i think i lost aprox 500gb which is not as important as wait another 4 weeks with perhaps no solution. So i yesterday deleted the raid and since this night i run badblocks on the disks to check them.

So presently no more help is needed, but i will thanks both of you for your help and fast replies. i think i gave xfs another chance and after all build up the server again with it.
best regards and sunny weekend

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
