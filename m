Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 891E97F5D
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 09:40:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6657630407E
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 07:40:20 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2QkDhXyyoIGH5RFB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 07:40:15 -0700 (PDT)
Message-ID: <5141E137.7010109@oracle.com>
Date: Thu, 14 Mar 2013 22:39:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: xfstest newbie
References: <CANBXnM=EVwsUb+oFMe9qHDGsCF+HwviFDKrz3qHVArWCGeEd6Q@mail.gmail.com>
In-Reply-To: <CANBXnM=EVwsUb+oFMe9qHDGsCF+HwviFDKrz3qHVArWCGeEd6Q@mail.gmail.com>
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
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: xfs@oss.sgi.com

Hi Adil,

On 03/14/2013 10:19 PM, Adil Mujeeb wrote:
> Hi list,
> 
> I would like to check xfstest.
> 
> Please help me in getting following:
> 
> 1. Sources (archive format)
You can refer to http://xfs.org/index.php/Getting_the_latest_source_code
to get the latest xfstests suits:
git clone git://oss.sgi.com/xfs/cmds/xfstests

> 2. Radme / user guide (e.g. how to conigure, build and run the tests etc.)
Please check the README file at xfstests directory, which includes all those
things about setup, build as well as how to execute test cases.

> 3. Open bug lists
> 4. Tutorials (if any)
README file also includes how to create a new test case and how to check the test result.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
