Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R0A7J7001305 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 18:10:07 -0600
Received: from imap.sh.mvista.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BE72BB059
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 16:09:24 -0800 (PST)
Received: from imap.sh.mvista.com (gateway-1237.mvista.com [63.81.120.155]) by
	cuda.sgi.com with ESMTP id t8HlDiiWkvc95iua for
	<xfs@oss.sgi.com>; Mon, 26 Jan 2009 16:09:24 -0800 (PST)
Message-ID: <497E4908.9060705@ru.mvista.com>
Date: Tue, 27 Jan 2009 02:36:40 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<20090126220210.GB26064@csclub.uwaterloo.ca>
In-Reply-To: <20090126220210.GB26064@csclub.uwaterloo.ca>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org

Hello.

Lennart Sorensen wrote:

>> It comes with one :)
>> # xfs_admin -u  /dev/sdd2
>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>
>> Will try to use this to boot; however, I'd prefer the labels over the 
>> UUID, wish there was an easy way to set it.
>>     
>
> I prefer UUIDs.
>
> Much mroe likely to have the same label on multiple drives than the same
> UUID.

   For example, CentOS 4.3 went crazy in such case, being unable to 
mount anything but root IIRC.

MBR, Sergei


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
