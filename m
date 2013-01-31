Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB1F27F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 12:28:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6F16304066
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 10:28:51 -0800 (PST)
Received: from mail-ye0-f181.google.com (mail-ye0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	NqsTg1iF1Ckzf8ct (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jan 2013 10:28:50 -0800 (PST)
Received: by mail-ye0-f181.google.com with SMTP id m11so680054yen.12
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 10:28:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510AB2D5.2080600@redhat.com>
References: <CA+kHd+eRifnCVkri6TPKS9UcUpBSW9nPnCEz0a412vO_Aw8=Xw@mail.gmail.com>
	<510AB2D5.2080600@redhat.com>
Date: Thu, 31 Jan 2013 19:28:49 +0100
Message-ID: <CAAxjCExedk+fWLpD1ypak9HK7b2domtc3aJuBRyEWsvXXsiSWA@mail.gmail.com>
Subject: Re: 50% more blocks allocated than needed
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

> I don't think so at the moment

Really? Even for closed files? I was almost sure that the space would
be reclaimed before running out of it. I have only slightly less than
1 year of XFS experience though...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
