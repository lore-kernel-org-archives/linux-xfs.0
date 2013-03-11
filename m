Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DEF57F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 04:25:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C224304032
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 02:25:15 -0700 (PDT)
Received: from mail-bk0-f43.google.com (mail-bk0-f43.google.com
	[209.85.214.43]) by cuda.sgi.com with ESMTP id zX1txrAJ4ImizsyI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Mar 2013 02:25:15 -0700 (PDT)
Received: by mail-bk0-f43.google.com with SMTP id jm19so1557409bkc.2
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 02:25:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513D1D51.7010905@hardwarefreak.com>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
	<20130309091152.GH23616@dastard>
	<513B84AD.2000603@hardwarefreak.com>
	<20130310224536.GK23616@dastard>
	<513D1D51.7010905@hardwarefreak.com>
Date: Mon, 11 Mar 2013 10:25:13 +0100
Message-ID: <CAPcwv6yb4F1b4hUiBmt3HNs-uTet812TVUN_-_y+JibAXkTQsw@mail.gmail.com>
Subject: Re: XFS filesystem corruption
From: Julien FERRERO <jferrero06@gmail.com>
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
To: stan@hardwarefreak.com
Cc: Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

>
> Ok, see, this is odd part here.  The OP didn't seem to have this
> metadata corruption issue with the old 2.6.18 kernel, at least I think
> that's the one he mentioned.  Then he switched to 2.6.35.  IIRC there
> were a number of commits around that time and some regressions.  I also
> recall 2.6.35 is not a long term stable kernel.  I'd guess there were
> reasons for that.  So, I'm wondering if there was a bug/regression
> relating to XFS metadata in 2.6.35 corrected in .36 or later and simply
> not backported.  Seems to ring a bell, vaguely.  I have no idea
> where/how to search for such information.
>

That is the main reason I asked. I google for regression / issue with
XFS in 2.6.35 but I didn't find anything. My hope was that someone
from this mailing list would remember it (if such a regression did
exist of course).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
